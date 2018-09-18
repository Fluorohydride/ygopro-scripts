--幻影騎士団ウロング・マグネリング
function c62645025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c62645025.condition)
	e1:SetTarget(c62645025.target)
	e1:SetOperation(c62645025.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c62645025.drcon)
	e2:SetCost(c62645025.drcost)
	e2:SetTarget(c62645025.drtg)
	e2:SetOperation(c62645025.drop)
	c:RegisterEffect(e2)
end
function c62645025.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c62645025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,62645025,0x10db,0x21,0,0,2,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c62645025.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateAttack() then return end
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,62645025,0x10db,0x21,0,0,2,RACE_WARRIOR,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT)
	Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP_ATTACK)
end
function c62645025.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c62645025.cfilter(c)
	if c:IsFacedown() or not c:IsAbleToGraveAsCost() then return false end
	return (c:IsSetCard(0x10db) and c:IsType(TYPE_MONSTER))
		or (c:IsSetCard(0xdb) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS))
end
function c62645025.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c62645025.cfilter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c62645025.cfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c62645025.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c62645025.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
