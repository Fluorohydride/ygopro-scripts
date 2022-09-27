--アロマガーデニング
function c29189613.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29189613,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,29189613)
	e2:SetCondition(c29189613.reccon)
	e2:SetTarget(c29189613.rectg)
	e2:SetOperation(c29189613.recop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29189613,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCountLimit(1,29189614)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c29189613.spcon)
	e4:SetTarget(c29189613.sptg)
	e4:SetOperation(c29189613.spop)
	c:RegisterEffect(e4)
end
function c29189613.cfilter(c,tp)
	return c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsSetCard(0xc9)
end
function c29189613.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29189613.cfilter,1,nil,tp)
end
function c29189613.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c29189613.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c29189613.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c29189613.spfilter(c,e,tp)
	return c:IsSetCard(0xc9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29189613.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29189613.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29189613.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29189613.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
