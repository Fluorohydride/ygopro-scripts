--十二獣の相剋
function c98918572.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98918572,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98918572)
	e2:SetCondition(c98918572.rcon)
	e2:SetOperation(c98918572.rop)
	c:RegisterEffect(e2)
	--attach
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c98918572.xyztg)
	e3:SetOperation(c98918572.xyzop)
	c:RegisterEffect(e3)
end
function c98918572.rfilter(c,oc,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and c:CheckRemoveOverlayCard(tp,oc,REASON_COST)
end
function c98918572.rcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:IsActivated()
		and re:IsActiveType(TYPE_XYZ) and ep==e:GetOwnerPlayer() and rc:IsSetCard(0xf1)
		and Duel.IsExistingMatchingCard(c98918572.rfilter,tp,LOCATION_MZONE,0,1,rc,ev,tp)
end
function c98918572.rop(e,tp,eg,ep,ev,re,r,rp)
	local min=ev&0xffff
	local max=(ev>>16)&0xffff
	local rc=re:GetHandler()
	local tg=Duel.SelectMatchingCard(tp,c98918572.rfilter,tp,LOCATION_MZONE,0,1,1,rc,min,tp)
	return tg:GetFirst():RemoveOverlayCard(tp,min,max,REASON_EFFECT)
end
function c98918572.xyzfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xf1) and c:IsCanBeEffectTarget(e)
end
function c98918572.gcheck(g)
	return g:IsExists(Card.IsCanOverlay,1,nil)
end
function c98918572.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c98918572.xyzfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(c98918572.gcheck,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c98918572.gcheck,false,2,2)
	Duel.SetTargetCard(sg)
end
function c98918572.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()~=2 then return end
	if g:IsExists(Card.IsImmuneToEffect,1,nil,e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local xc=g:FilterSelect(tp,Card.IsCanOverlay,1,1,nil):GetFirst()
	if xc then
		local tc=(g-xc):GetFirst()
		local og=xc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,xc)
	end
end
