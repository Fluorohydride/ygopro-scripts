--Mitsurugi Mirror
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,13332685,19899073,55397172)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,s.spfilter,LOCATION_HAND+LOCATION_GRAVE,nil,s.mfilter,true)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.spfilter(c)
	return c:IsRace(RACE_REPTILE)
end
function s.mfilter(c)
	return c:IsRace(RACE_REPTILE)
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
		and (c:GetPreviousCodeOnField()==13332685 or c:GetPreviousCodeOnField()==19899073 or c:GetPreviousCodeOnField()==55397172)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and aux.NecroValleyFilter()(c) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
