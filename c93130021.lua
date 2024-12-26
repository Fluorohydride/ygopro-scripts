--ビクトリー・バイパー XX03
---@param c Card
function c93130021.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93130021,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c93130021.condition)
	e1:SetTarget(c93130021.target)
	e1:SetOperation(c93130021.operation)
	c:RegisterEffect(e1)
end
function c93130021.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c93130021.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c93130021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c93130021.filter(chkc) end
	if chk==0 then return true end
	local c=e:GetHandler()
	local t1=Duel.IsExistingTarget(c93130021.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local t2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(93130021,0))
	local op=0
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(93130021,1),aux.Stringid(93130021,2),aux.Stringid(93130021,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(93130021,1),aux.Stringid(93130021,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(93130021,1),aux.Stringid(93130021,3))
		if op==1 then op=2 end
	else
		op=Duel.SelectOption(tp,aux.Stringid(93130021,1))
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c93130021.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetProperty(0)
	end
end
function c93130021.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif e:GetLabel()==2 then
		local atk=c:GetAttack()
		local def=c:GetDefense()
		local lv=c:GetLevel()
		local race=c:GetRace()
		local att=c:GetAttribute()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) or c:IsFacedown()
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,TYPES_TOKEN_MONSTER,atk,def,lv,race,att) then return end
		local token=Duel.CreateToken(tp,93130022)
		c:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE,EFFECT_FLAG2_OPTION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c93130021.tokenatk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c93130021.tokendef)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(c93130021.tokenlv)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(c93130021.tokenrace)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(c93130021.tokenatt)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_ADJUST)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCondition(c93130021.tokendescon)
		e6:SetOperation(c93130021.tokendesop)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
	else
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(400)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
function c93130021.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function c93130021.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function c93130021.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function c93130021.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function c93130021.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function c93130021.tokendescon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c93130021.tokendesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end
