--オルターガイスト・エミュレルフ
---@param c Card
function c86885905.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c86885905.target)
	e1:SetOperation(c86885905.activate)
	c:RegisterEffect(e1)
	--untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c86885905.condition)
	e2:SetTarget(c86885905.etarget)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(c86885905.condition)
	e3:SetTarget(c86885905.etarget)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c86885905.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,86885905,0x103,TYPES_EFFECT_TRAP_MONSTER,1400,1800,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c86885905.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,86885905,0x103,TYPES_EFFECT_TRAP_MONSTER,1400,1800,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_TRAP+TYPE_EFFECT)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end
function c86885905.condition(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c86885905.etarget(e,c)
	return c:IsSetCard(0x103) and c:IsType(TYPE_TRAP) and c~=e:GetHandler()
end
