--Solo the Melodious Songstress
function c14763299.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c14763299.spcon)
    c:RegisterEffect(e1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14763299,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetCondition(c14763299.condition)
    e1:SetTarget(c14763299.target)
    e1:SetOperation(c14763299.operation)
    c:RegisterEffect(e1)
end
function c14763299.spcon(e,c)
    if c==nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c14763299.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c14763299.filter(c,e,tp)
    return c:IsSetCard(0x9b) and c:GetCode()~=14763299 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14763299.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14763299.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c14763299.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14763299.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end