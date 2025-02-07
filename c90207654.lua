--極星天グルヴェイグ
function c90207654.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c90207654.matfilter,1,1)
	--banish and summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90207654,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,90207654)
	e1:SetCondition(c90207654.spcon)
	e1:SetTarget(c90207654.sptg)
	e1:SetOperation(c90207654.spop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c90207654.tgcon)
	e2:SetTarget(c90207654.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c90207654.tgcon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
end
function c90207654.matfilter(c)
	return c:IsLinkSetCard(0x42) and c:IsLevelBelow(5)
end
function c90207654.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c90207654.rmfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c90207654.spfilter(c,e,tp)
	return c:IsSetCard(0x42) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c90207654.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c90207654.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c90207654.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c90207654.gcheck(tp)
	return	function(sg)
				return Duel.GetMZoneCount(tp,sg)>=#sg
			end
end
function c90207654.spop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local ct=Duel.GetMatchingGroupCount(c90207654.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if ct>3 then ct=3 end
	if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=c90207654.gcheck(tp)
	local sg=rg:SelectSubGroup(tp,aux.TRUE,false,1,ct)
	aux.GCheckAdditional=nil
	if sg and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then
		local ct=#(Duel.GetOperatedGroup())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c90207654.spfilter,tp,LOCATION_DECK,0,ct,ct,nil,e,tp)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c90207654.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
end
function c90207654.splimit(e,c)
	return not c:IsSetCard(0x4b)
end
function c90207654.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4b)
end
function c90207654.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():IsExists(c90207654.tgfilter,1,nil)
end
function c90207654.tgtg(e,c)
	return c90207654.tgfilter(c) and e:GetHandler():GetLinkedGroup():IsContains(c)
end
