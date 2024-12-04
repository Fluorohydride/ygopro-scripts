--ドラグニティアームズ－グラム
function c53184342.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53184342,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,53184342)
	e1:SetCost(c53184342.spcost)
	e1:SetTarget(c53184342.sptg)
	e1:SetOperation(c53184342.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53184342,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,53184343)
	e2:SetTarget(c53184342.distg)
	e2:SetOperation(c53184342.disop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCountLimit(1,53184344)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c53184342.eqcon)
	e3:SetTarget(c53184342.eqtg)
	e3:SetOperation(c53184342.eqop)
	c:RegisterEffect(e3)
end
function c53184342.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_DRAGON+RACE_WINDBEAST)
end
function c53184342.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53184342.spcostfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c53184342.spcostfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c53184342.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c53184342.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c53184342.disfilter(c,eq)
	return aux.NegateMonsterFilter(c) or eq and c:IsFaceup() and c:GetAttack()>0
end
function c53184342.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local eq=Duel.IsExistingMatchingCard(c53184342.eqfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c53184342.disfilter(chkc,eq) end
	if chk==0 then return Duel.IsExistingTarget(c53184342.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,eq) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,c53184342.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,eq)
end
function c53184342.eqfilter(c)
	return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP)
end
function c53184342.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local ct=Duel.GetMatchingGroupCount(c53184342.eqfilter,tp,LOCATION_ONFIELD,0,nil)
		if ct>0 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(-ct*1000)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end
function c53184342.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:IsPreviousControler(1-tp) and c:IsType(TYPE_MONSTER)
end
function c53184342.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c53184342.cfilter,1,nil,tp)
end
function c53184342.chkfilter(c,tp)
	return not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c53184342.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp)
		and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and c53184342.chkfilter(c,tp)
end
function c53184342.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c53184342.filter,nil,tp)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=#g end
	Duel.SetTargetCard(g)
end
function c53184342.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(aux.NecroValleyFilter(c53184342.chkfilter),nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsFaceup() and c:IsRelateToEffect(e) and #g>0 and ft>0 then
		local sg=nil
		if #g>ft then
			sg=g:Select(tp,ft,ft,nil)
		else
			sg=g
		end
		local tc=sg:GetFirst()
		while tc do
			if Duel.Equip(tp,tc,c,true,true) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c53184342.eqlimit)
				tc:RegisterEffect(e1)
			end
			tc=sg:GetNext()
		end
		Duel.EquipComplete()
	end
end
function c53184342.eqlimit(e,c)
	return e:GetOwner()==c
end
