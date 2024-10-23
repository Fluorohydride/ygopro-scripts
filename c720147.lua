--王の憤激
function c720147.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,720147+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c720147.cost)
	e1:SetTarget(c720147.target)
	e1:SetOperation(c720147.activate)
	c:RegisterEffect(e1)
end
function c720147.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c720147.costfilter(c,tp)
	return c:IsSetCard(0x134) and Duel.IsExistingTarget(c720147.matfilter1,tp,LOCATION_MZONE,0,1,c,tp,Group.FromCards(c))
end
function c720147.matfilter1(c,tp,g)
	local sg=g:Clone()
	sg:AddCard(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c720147.matfilter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,g:GetCount(),sg)
end
function c720147.matfilter2(c)
	return c:IsSetCard(0x134) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c720147.fselect(g,tp)
	return Duel.IsExistingTarget(c720147.matfilter1,tp,LOCATION_MZONE,0,1,g,tp,g)
		and Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
end
function c720147.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c720147.matfilter1(chkc,tp,g) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		return Duel.CheckReleaseGroup(tp,c720147.costfilter,1,nil,tp)
	end
	local rg=Duel.GetReleaseGroup(tp):Filter(c720147.costfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c720147.fselect,false,1,rg:GetCount(),tp)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	aux.UseExtraReleaseCount(sg,tp)
	Duel.Release(sg,REASON_COST)
	for rc in aux.Next(sg) do
		rc:CreateEffectRelation(e)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c720147.matfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,sg)
end
function c720147.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local rg=e:GetLabelObject()
		local exg=rg:Filter(Card.IsRelateToEffect,nil,e)
		exg:AddCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c720147.matfilter2),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,rg:GetCount(),rg:GetCount(),exg)
		if g:GetCount()>0 then
			for oc in aux.Next(g) do
				local og=oc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
			end
			Duel.Overlay(tc,g)
		end
	end
end
