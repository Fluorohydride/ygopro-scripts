--アルカナフォースEX－THE CHAOS RULER
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,73206827)
	--fusion summon
	aux.AddFusionProcFunRep(c,s.ffilter,3,false)
	c:EnableReviveLimit()
	aux.AddContactFusionProcedure(c,s.cffilter,LOCATION_MZONE,LOCATION_MZONE,Duel.SendtoGrave,REASON_COST)
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.cointg)
	e1:SetOperation(s.coinop)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.condition)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
end
s.toss_coin=true
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x5) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function s.cffilter(c,fc)
	return c:IsAbleToGraveAsCost() and (c:IsControler(fc:GetControler()) or c:IsFaceup())
end
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5) and c:IsLevel(10) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.thfilter(c)
	return c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_COIN)) and c:IsAbleToHand()
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=-1
	if Duel.IsPlayerAffectedByEffect(tp,73206827) then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
		local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		if b1 and not b2 then
			Duel.Hint(HINT_OPSELECTED,1-tp,60)
			res=1
		end
		if b2 and not b1 then
			Duel.Hint(HINT_OPSELECTED,1-tp,61)
			res=0
		end
		if b1 and b2 then
			res=aux.SelectFromOptions(tp,
				{b1,60,1},
				{b2,61,0})
		end
	else res=Duel.TossCoin(tp,1) end
	if res==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	elseif res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.condition(e)
	return Duel.IsEnvironment(73206827,PLAYER_ALL,LOCATION_FZONE)
end
function s.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc&LOCATION_ONFIELD~=0 and re:IsActiveType(TYPE_MONSTER)
end
