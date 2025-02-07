--魂喰魔獣 バズー
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.rmtg)
	e1:SetTargetRange(0xff,0xff)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--remove material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.ovcon)
	e2:SetTarget(s.ovtg)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
	--be material from grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_DETACH_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(s.matcon)
	e3:SetTarget(s.mattg)
	e3:SetOperation(s.matop)
	c:RegisterEffect(e3)
end
function s.rmtg(e,c)
	return (c:IsLocation(LOCATION_OVERLAY) or c:IsPreviousLocation(LOCATION_OVERLAY))
		and c:IsReason(REASON_COST+REASON_SPSUMMON+REASON_EFFECT)
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetCount()==0
end
function s.mattgfilter(c,sc)
	return c:IsCanOverlay()
end
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.mattgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,s.mattgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,3,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
end
function s.mafilter(c,e)
	return not c:IsImmuneToEffect(e) and c:IsCanOverlay()
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain():Filter(aux.NecroValleyFilter(s.mafilter),nil,e)
	if c:IsRelateToChain() and #g>0 then
		Duel.Overlay(c,g)
	end
end
