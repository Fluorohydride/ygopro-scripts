--死霊王 ドーハスーラ
function c39185163.initial_effect(c)
	--negate / banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39185163,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c39185163.disrmcon)
	e1:SetTarget(c39185163.disrmtg)
	e1:SetOperation(c39185163.disrmop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39185163,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1,39185163)
	e2:SetCondition(c39185163.spcon)
	e2:SetTarget(c39185163.sptg)
	e2:SetOperation(c39185163.spop)
	c:RegisterEffect(e2)
end
function c39185163.disrmcon(e,tp,eg,ep,ev,re,r,rp)
	local race,code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	return re:IsActiveType(TYPE_MONSTER) and race&RACE_ZOMBIE>0 and code1~=39185163 and code2~=39185163
end
function c39185163.disrmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,39185163)==0
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
		and Duel.GetFlagEffect(tp,39185164)==0
	if chk==0 then return b1 or b2 end
end
function c39185163.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c39185163.disrmop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,39185163)==0
	local b2=Duel.IsExistingMatchingCard(c39185163.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
		and Duel.GetFlagEffect(tp,39185164)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(39185163,1),aux.Stringid(39185163,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(39185163,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(39185163,2))+1
	else return end
	if op==0 then
		Duel.NegateEffect(ev)
		Duel.RegisterFlagEffect(tp,39185163,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=aux.SelectCardFromFieldFirst(tp,c39185163.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,39185164,RESET_PHASE+PHASE_END,0,1)
	end
end
function c39185163.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c39185163.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c39185163.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
