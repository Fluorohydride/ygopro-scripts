--合体術式－エンゲージ・ゼロ
local s,id=GetID()
function s.initial_effect(c)
    c:SetSPSummonOnce(100296003)
    --Link Summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK),2,2)
    --Cannot be used as Link Material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --When Special Summoned
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetTarget(s.SummonedTarget)
    e2:SetOperation(s.SummonedOperation)
    c:RegisterEffect(e2)
    --At the start of the Damage Step
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e3:SetCondition(s.DestructionCondition)
    e3:SetTarget(s.DestructionTarget)
    e3:SetOperation(s.DestructionOperation)
    c:RegisterEffect(e3)
end
--Target 1 monster your opponent controls with 2500 or more ATK
function s.SummonedTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:GetAttack()>=2500 end
    if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:GetAttack()>=2500 end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:GetAttack()>=2500 end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
--Negate that targeted monster's effects until the end of the turn
function s.SummonedOperation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
--Condition for the destruction effect
function s.DestructionCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
        --Sky Striker Ace - Raye
        and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,26077387)
        --Sky Striker Ace - Roze
        and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,37351133)
end
--Target for the destruction effect
function s.DestructionTarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_MZONE,nil,e)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
--Operation for the destruction effect
function s.DestructionOperation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_MZONE,nil,e)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end