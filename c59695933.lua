--インターセプト
function c59695933.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c59695933.condition)
	e1:SetTarget(c59695933.target)
	e1:SetOperation(c59695933.activate)
	c:RegisterEffect(e1)
	if not c59695933.global_check then
		c59695933.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c59695933.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c59695933.valcheck(e,c)
	if c:GetMaterialCount()==1 and c:GetMaterial():GetFirst():IsType(TYPE_MONSTER) then
		c:RegisterFlagEffect(59695933,0,0,0)
	end
end
function c59695933.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local res=tc:IsSummonType(SUMMON_TYPE_ADVANCE) and tc:GetFlagEffect(59695933)~=0
	tc:ResetFlagEffect(59695933)
	return res
end
function c59695933.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return eg:GetFirst():IsCanBeEffectTarget(e) and eg:GetFirst():IsControlerCanBeChanged() end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
end
function c59695933.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
