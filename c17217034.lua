--"Combination Maneuver - Engage Zero"
--Ultigon
local s,id=GetID()
local list={26077387,37351133}
function s.initial_effect(c)
    --You can only Special Summon "Combination Maneuver - Engage Zero(s)" once per turn.
    c:SetSPSummonOnce(m)
    --Link Materials: 2 LIGHT and/or DARK monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK),2,2)
    --Cannot be used as Link Material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --If this card is Special Summoned: You can target 1 monster on the field with 2500 or more ATK; negate its effects until the end of this turn.
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetTarget(s.NegateTarget)
    e2:SetOperation(s.NegateOperation)
    c:RegisterEffect(e2)
    --At the start of the Damage Step, if this card attacks and you have "Sky Striker Ace - Raye" and "Sky Striker Ace - Roze" in your GY: You can destroy all monsters your opponent controls.
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e3:SetCondition(s.ManeuverCondition)
    e3:SetOperation(s.ManeuverOperation)
    c:RegisterEffect(e3)
    --This card is always treated as a "Sky Striker Ace" card
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_ADD_SETCODE)
    e4:SetValue(0x1115)
    c:RegisterEffect(e4)
end

--[e2] Target 1 monster on the field with 2500 or more ATK
function s.NegateTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:GetAttack()>=2500 end
    if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:GetAttack()>=2500 end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:GetAttack()>=2500 end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
    end
end
--[e2] Negate that targeted monster's effects until the end of the turn
function s.NegateOperation(e,tp,eg,ep,ev,re,r,rp)
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

--[e3] If this card attacks and you have "Sky Striker Ace - Raye" and "Sky Striker Ace - Roze" in your GY:
function s.ManeuverCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
        --Sky Striker Ace - Raye
        and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,list[1])
        --Sky Striker Ace - Roze
        and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,list[2])
end
--[e3] You can destroy all monsters your opponent controls.
function s.ManeuverOperation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_MZONE,nil,e)
    if g:GetCount()>0 then
        if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
end