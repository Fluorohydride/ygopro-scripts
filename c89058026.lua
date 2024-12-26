--ENウェーブ
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	aux.AddCodeList(c,89943723)
	aux.AddSetNameMonsterList(c,0x3008)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- Special Summon from Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.dspcon)
	e1:SetTarget(s.dsptg)
	e1:SetOperation(s.dspop)
	c:RegisterEffect(e1)
	-- Special Summon from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.gspcon)
	e2:SetTarget(s.gsptg)
	e2:SetOperation(s.gspop)
	c:RegisterEffect(e2)
end
function s.dspconfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
		and (c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousSetCard(0x3008)
			or not c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x3008))
end
function s.dspcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION and eg:IsExists(s.dspconfilter,1,nil,tp)
end
function s.dspfilter(c,e,tp)
	return (c:IsSetCard(0x1f) or c:IsCode(89943723)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.dspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.dspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.gspconfilter(c,tp)
	return ((c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1f)) or c:IsCode(89943723))
		and c:IsPreviousControler(tp) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_GRAVE)
end
function s.gspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.gspconfilter,1,nil,tp)
end
function s.gspfilter(c,e,tp)
	return c:IsSetCard(0x3008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.gsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.gspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.gspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.gspfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
